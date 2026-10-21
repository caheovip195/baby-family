import { X509Certificate, timingSafeEqual } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { compactVerify, decodeProtectedHeader } from 'jose';
import { DomainError } from '../common/errors/domain.error';
import { STORE_PUBLISHER } from '../interfaces/services/store-publisher.interface';
import type { IStorePublisher } from '../interfaces/services/store-publisher.interface';
import type {
  IStoreVerifier,
  VerifiedStoreNotification,
  VerifiedStorePurchase,
  VerifyStorePurchaseInput,
} from '../interfaces/services/store-verifier.interface';

@Injectable()
export class StoreVerifierService implements IStoreVerifier {
  constructor(
    private readonly config: ConfigService,
    @Inject(STORE_PUBLISHER) private readonly publisher: IStorePublisher,
  ) {}

  async verifyPurchase(
    input: VerifyStorePurchaseInput,
  ): Promise<VerifiedStorePurchase> {
    const purchase =
      input.store === 'APP_STORE'
        ? await this.applePurchase(this.required(input.signedTransaction))
        : await this.publisher.getSubscription(
            this.setting('PLAY_PACKAGE_NAME'),
            this.required(input.purchaseToken),
          );
    if (
      purchase.store !== input.store ||
      (input.productId !== undefined &&
        purchase.productId !== input.productId) ||
      (input.accountToken !== undefined &&
        purchase.accountToken !== input.accountToken)
    )
      throw this.invalid();
    if (input.store === 'PLAY') {
      if (purchase.appNamespace !== this.setting('PLAY_PACKAGE_NAME'))
        throw this.invalid();
      purchase.purchaseToken = input.purchaseToken;
    }
    return purchase;
  }

  async verifyAppStoreNotification(
    signedPayload: string,
  ): Promise<VerifiedStoreNotification> {
    const raw = await this.appleJws(signedPayload);
    const data = this.record(raw.data);
    this.assertAppleNamespace(data);
    const notificationType = this.required(raw.notificationType);
    let type: VerifiedStoreNotification['type'] = 'IGNORED';
    if (
      ['SUBSCRIBED', 'DID_RENEW', 'OFFER_REDEEMED'].includes(notificationType)
    )
      type = 'RENEWED';
    if (['EXPIRED', 'GRACE_PERIOD_EXPIRED'].includes(notificationType))
      type = 'EXPIRED';
    if (
      notificationType === 'DID_FAIL_TO_RENEW' &&
      raw.subtype === 'GRACE_PERIOD'
    )
      type = 'GRACE';
    if (['REFUND', 'REVOKE'].includes(notificationType)) type = 'REVOKED';
    if (notificationType === 'DID_CHANGE_RENEWAL_STATUS')
      type = 'AUTO_RENEW_CHANGED';
    const purchase =
      typeof data.signedTransactionInfo === 'string'
        ? await this.applePurchase(data.signedTransactionInfo)
        : null;
    let autoRenew: boolean | undefined;
    if (typeof data.signedRenewalInfo === 'string') {
      const renewal = await this.appleJws(data.signedRenewalInfo);
      if (
        !purchase ||
        renewal.originalTransactionId !== purchase.originalTransactionId ||
        String(renewal.environment).toUpperCase() !== purchase.environment
      )
        throw this.invalid();
      if (renewal.autoRenewStatus !== 0 && renewal.autoRenewStatus !== 1)
        throw this.invalid();
      autoRenew = renewal.autoRenewStatus === 1;
      purchase.autoRenew = autoRenew;
      if (renewal.gracePeriodExpiresDate !== undefined)
        purchase.graceUntil = this.date(renewal.gracePeriodExpiresDate);
    }
    if (type !== 'IGNORED' && !purchase) throw this.invalid();
    return {
      store: 'APP_STORE',
      eventId: this.required(raw.notificationUUID),
      type,
      occurredAt: this.date(raw.signedDate),
      environment: this.required(data.environment).toUpperCase(),
      appNamespace: this.required(data.bundleId),
      purchase,
      autoRenew,
      raw,
    };
  }

  async verifyPlayNotification(input: {
    authorization: string | undefined;
    body: unknown;
  }): Promise<VerifiedStoreNotification> {
    const expected = 'Bearer ' + this.setting('PLAY_WEBHOOK_TOKEN');
    const supplied = Buffer.from(input.authorization ?? '');
    const secret = Buffer.from(expected);
    if (supplied.length !== secret.length || !timingSafeEqual(supplied, secret))
      throw new DomainError(
        'Invalid store webhook credentials.',
        'STORE_WEBHOOK_UNAUTHORIZED',
        401,
      );
    const envelope = this.record(input.body);
    const message = this.record(envelope.message);
    let raw: Record<string, unknown>;
    try {
      raw = this.record(
        JSON.parse(
          Buffer.from(this.required(message.data), 'base64').toString('utf8'),
        ),
      );
    } catch {
      throw this.invalid();
    }
    if (raw.packageName !== this.setting('PLAY_PACKAGE_NAME'))
      throw this.invalid();
    const notification =
      raw.subscriptionNotification === undefined
        ? null
        : this.record(raw.subscriptionNotification);
    const types: Record<number, VerifiedStoreNotification['type']> = {
      1: 'RENEWED',
      2: 'RENEWED',
      3: 'AUTO_RENEW_CHANGED',
      4: 'RENEWED',
      5: 'EXPIRED',
      6: 'GRACE',
      7: 'RENEWED',
      10: 'EXPIRED',
      12: 'REVOKED',
      13: 'EXPIRED',
    };
    const type = notification
      ? (types[Number(notification.notificationType)] ?? 'IGNORED')
      : 'IGNORED';
    const purchase = notification
      ? await this.verifyPurchase({
          store: 'PLAY',
          purchaseToken: this.required(notification.purchaseToken),
        })
      : null;
    return {
      store: 'PLAY',
      eventId: this.required(message.messageId),
      occurredAt: this.date(Number(raw.eventTimeMillis)),
      environment:
        purchase?.environment ?? this.setting('IAP_ENVIRONMENT').toUpperCase(),
      appNamespace: this.required(raw.packageName),
      type,
      purchase,
      autoRenew: purchase?.autoRenew,
      raw: { payload: raw, messageId: message.messageId },
    };
  }

  private async applePurchase(
    signedTransaction: string,
  ): Promise<VerifiedStorePurchase> {
    const raw = await this.appleJws(signedTransaction);
    this.assertAppleNamespace(raw);
    return {
      store: 'APP_STORE',
      transactionId: this.required(raw.transactionId),
      originalTransactionId: this.required(raw.originalTransactionId),
      productId: this.required(raw.productId),
      accountToken: this.required(raw.appAccountToken),
      appNamespace: this.required(raw.bundleId),
      startsAt: this.date(raw.purchaseDate),
      expiresAt: this.date(raw.expiresDate),
      autoRenew: true,
      environment: this.required(raw.environment).toUpperCase(),
      revokedAt:
        raw.revocationDate === undefined
          ? undefined
          : this.date(raw.revocationDate),
      raw,
    };
  }

  private async appleJws(jws: string): Promise<Record<string, unknown>> {
    const rootConfig = this.setting('APP_STORE_ROOT_CERTIFICATES_JSON');
    try {
      const rootPems: unknown = JSON.parse(rootConfig);
      if (
        !Array.isArray(rootPems) ||
        !rootPems.length ||
        !rootPems.every((pem: unknown) => typeof pem === 'string')
      )
        throw this.invalid();
      const roots = rootPems.map((pem) => new X509Certificate(pem));
      const header = decodeProtectedHeader(jws);
      if (
        header.alg !== 'ES256' ||
        !header.x5c ||
        header.x5c.length < 2 ||
        header.x5c.length > 5
      )
        throw this.invalid();
      const chain = header.x5c.map(
        (der) => new X509Certificate(Buffer.from(der, 'base64')),
      );
      const leaf = chain[0]!;
      if (
        leaf.ca ||
        !this.hasExtension(leaf, '2a864886f76364060b01') ||
        !this.hasExtension(chain[1]!, '2a864886f76364060201')
      )
        throw this.invalid();
      for (let index = 0; index < chain.length - 1; index++) {
        const certificate = chain[index]!;
        const issuer = chain[index + 1]!;
        if (
          !issuer.ca ||
          !certificate.checkIssued(issuer) ||
          !certificate.verify(issuer.publicKey)
        )
          throw this.invalid();
      }
      const last = chain[chain.length - 1]!;
      const anchor = roots.find(
        (root) =>
          root.ca &&
          (root.fingerprint256 === last.fingerprint256 ||
            (last.checkIssued(root) && last.verify(root.publicKey))),
      );
      if (!anchor) throw this.invalid();
      const result = await compactVerify(jws, leaf.publicKey, {
        algorithms: ['ES256'],
      });
      const payload: unknown = JSON.parse(
        Buffer.from(result.payload).toString('utf8'),
      );
      const raw = this.record(payload);
      const signedAt = this.date(raw.signedDate).getTime();
      if (signedAt > Date.now() + 300_000) throw this.invalid();
      for (const certificate of [...chain, anchor]) {
        if (
          signedAt < Date.parse(certificate.validFrom) ||
          signedAt > Date.parse(certificate.validTo)
        )
          throw this.invalid();
      }
      return raw;
    } catch {
      throw this.invalid();
    }
  }
  /** Read extension OIDs at their ASN.1 extension boundary, never by substring. */
  private hasExtension(certificate: X509Certificate, oidHex: string): boolean {
    const der = certificate.raw;
    const children = (
      start: number,
      end: number,
    ): { tag: number; start: number; end: number }[] => {
      const nodes: { tag: number; start: number; end: number }[] = [];
      let offset = start;
      while (offset < end) {
        const tag = der[offset++]!;
        let length = der[offset++]!;
        if (length & 128) {
          const bytes = length & 127;
          if (bytes === 0 || bytes > 4 || offset + bytes > end)
            throw this.invalid();
          length = 0;
          for (let index = 0; index < bytes; index++)
            length = length * 256 + der[offset++]!;
        }
        if (offset + length > end) throw this.invalid();
        nodes.push({ tag, start: offset, end: offset + length });
        offset += length;
      }
      return nodes;
    };
    const certificateNode = children(0, der.length)[0];
    if (!certificateNode || certificateNode.tag !== 48) return false;
    const tbs = children(certificateNode.start, certificateNode.end)[0];
    if (!tbs || tbs.tag !== 48) return false;
    const extensions = children(tbs.start, tbs.end).find(
      (node) => node.tag === 163,
    );
    if (!extensions) return false;
    const sequence = children(extensions.start, extensions.end)[0];
    if (!sequence || sequence.tag !== 48) return false;
    return children(sequence.start, sequence.end).some((extension) => {
      if (extension.tag !== 48) return false;
      const oid = children(extension.start, extension.end)[0];
      return (
        oid?.tag === 6 &&
        der.subarray(oid.start, oid.end).toString('hex') === oidHex
      );
    });
  }
  private assertAppleNamespace(raw: Record<string, unknown>): void {
    if (
      raw.bundleId !== this.setting('APP_STORE_BUNDLE_ID') ||
      String(raw.environment).toUpperCase() !==
        (
          this.config.get<string>('APP_STORE_ENVIRONMENT') ??
          this.setting('IAP_ENVIRONMENT')
        ).toUpperCase()
    )
      throw this.invalid();
  }
  private setting(key: string): string {
    const value = this.config.get<string>(key);
    if (!value?.trim())
      throw new DomainError(
        'Store verification is not configured.',
        'STORE_VERIFIER_UNAVAILABLE',
        503,
      );
    return value;
  }
  private record(value: unknown): Record<string, unknown> {
    if (!value || typeof value !== 'object' || Array.isArray(value))
      throw this.invalid();
    return value as Record<string, unknown>;
  }
  private required(value: unknown): string {
    if (typeof value !== 'string' || !value.trim()) throw this.invalid();
    return value;
  }
  private date(value: unknown): Date {
    if (typeof value !== 'number' || !Number.isFinite(value) || value <= 0)
      throw this.invalid();
    const date = new Date(value);
    if (!Number.isFinite(date.getTime())) throw this.invalid();
    return date;
  }
  private invalid(): DomainError {
    return new DomainError(
      'Store evidence is invalid.',
      'STORE_VERIFICATION_FAILED',
      422,
    );
  }
}

import type { Provider, Type } from '@nestjs/common';
import { INTERNAL_SERVICE_PROVIDERS } from './service.providers';
import { AccessTokenGuard } from '../auth/access-token.guard';
import { AUTHENTICATION_SERVICE } from '../../interfaces/services/authentication-service.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../interfaces/services/application-access-service.interface';
import { AuthenticationService } from '../../services/authentication.service';
import { ApplicationAccessService } from '../../services/application-access.service';
import { AUTH_ACCESS_REPOSITORY } from '../../interfaces/repositories/auth-access-repository.interface';
import { AuthAccessRepository } from '../../repositories/auth-access.repository';
import { CATALOG_QUERY_REPOSITORY } from '../../interfaces/repositories/catalog-query-repository.interface';
import { CatalogQueryRepository } from '../../repositories/catalog-query.repository';
import { USER_SERVICE } from '../../interfaces/services/user-service.interface';
import { UserService } from '../../services/user.service';
import { UserController } from '../../controllers/user.controller';
import { USER_SETTING_SERVICE } from '../../interfaces/services/user-setting-service.interface';
import { UserSettingService } from '../../services/user-setting.service';
import { UserSettingController } from '../../controllers/user-setting.controller';
import { FAMILY_SERVICE } from '../../interfaces/services/family-service.interface';
import { FamilyService } from '../../services/family.service';
import { FamilyController } from '../../controllers/family.controller';
import { CHILD_SERVICE } from '../../interfaces/services/child-service.interface';
import { ChildService } from '../../services/child.service';
import { ChildController } from '../../controllers/child.controller';
import { PREGNANCY_SERVICE } from '../../interfaces/services/pregnancy-service.interface';
import { PregnancyService } from '../../services/pregnancy.service';
import { PregnancyController } from '../../controllers/pregnancy.controller';
import { PREGNANCY_COMMAND_REPOSITORY } from '../../interfaces/repositories/pregnancy-command-repository.interface';
import { PregnancyCommandRepository } from '../../repositories/pregnancy-command.repository';
import { BILLING_CATALOG_SERVICE } from '../../interfaces/services/billing-catalog-service.interface';
import { BillingCatalogService } from '../../services/billing-catalog.service';
import { BillingCatalogController } from '../../controllers/billing-catalog.controller';
import { FAMILY_BILLING_SERVICE } from '../../interfaces/services/family-billing-service.interface';
import { FamilyBillingService } from '../../services/family-billing.service';
import { FamilyBillingController } from '../../controllers/family-billing.controller';
import { MEDIA_SERVICE } from '../../interfaces/services/media-service.interface';
import { MediaService } from '../../services/media.service';
import { MediaController } from '../../controllers/media.controller';
import { MEDIA_REPOSITORY } from '../../interfaces/repositories/media-repository.interface';
import { MediaRepository } from '../../repositories/media.repository';

export const APPLICATION_CONTROLLERS: Type[] = [
  UserController,
  UserSettingController,
  FamilyController,
  ChildController,
  PregnancyController,
  BillingCatalogController,
  FamilyBillingController,
  MediaController,
];

export const APPLICATION_PROVIDERS: Provider[] = [
  ...INTERNAL_SERVICE_PROVIDERS,
  AccessTokenGuard,
  { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
  { provide: CATALOG_QUERY_REPOSITORY, useClass: CatalogQueryRepository },
  { provide: MEDIA_REPOSITORY, useClass: MediaRepository },
  { provide: MEDIA_SERVICE, useClass: MediaService },
  {
    provide: PREGNANCY_COMMAND_REPOSITORY,
    useClass: PregnancyCommandRepository,
  },
  { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
  { provide: APPLICATION_ACCESS_SERVICE, useClass: ApplicationAccessService },
  { provide: USER_SERVICE, useClass: UserService },
  { provide: USER_SETTING_SERVICE, useClass: UserSettingService },
  { provide: FAMILY_SERVICE, useClass: FamilyService },
  { provide: CHILD_SERVICE, useClass: ChildService },
  { provide: PREGNANCY_SERVICE, useClass: PregnancyService },
  { provide: BILLING_CATALOG_SERVICE, useClass: BillingCatalogService },
  { provide: FAMILY_BILLING_SERVICE, useClass: FamilyBillingService },
];

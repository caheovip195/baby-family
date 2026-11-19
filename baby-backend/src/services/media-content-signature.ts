/**
 * Container detection from the first bytes of a stored object (magic numbers).
 * Content-Type, POST policies and checksums only prove the client sent what it
 * declared; this catches a body whose format differs from the declared MIME
 * (e.g. an MP4 uploaded as `image/jpeg`). No decoding, a few KiB read per file.
 */

/** Bytes the detector needs; ISO-BMFF `ftyp` lists brands within this range. */
export const MEDIA_SIGNATURE_PREFIX_BYTES = 4096;

/** Detected container, coarser than MIME where the header cannot tell more. */
export type MediaContainer =
  | 'jpeg'
  | 'png'
  | 'gif'
  | 'webp'
  | 'heif'
  | 'avif'
  | 'mp4'
  | 'm4a'
  | 'quicktime'
  | 'mp3'
  | 'aac'
  | 'unknown';

/**
 * Which containers each declared MIME accepts. MP4 and M4A share ISO-BMFF
 * brands (`isom`, `mp42`…), so either can carry audio-only or video tracks;
 * the header alone cannot tell them apart without parsing `moov`.
 */
const ACCEPTED: Readonly<Record<string, readonly MediaContainer[]>> = {
  'image/jpeg': ['jpeg'],
  'image/png': ['png'],
  'image/gif': ['gif'],
  'image/webp': ['webp'],
  'image/heic': ['heif'],
  'image/heif': ['heif'],
  'image/avif': ['avif'],
  'video/mp4': ['mp4', 'm4a'],
  'video/quicktime': ['quicktime', 'mp4'],
  'audio/mp4': ['m4a', 'mp4'],
  'audio/x-m4a': ['m4a', 'mp4'],
  'audio/aac': ['aac', 'm4a', 'mp4'],
  'audio/mpeg': ['mp3'],
};

const HEIF_BRANDS = new Set([
  'heic',
  'heix',
  'hevc',
  'hevx',
  'heim',
  'heis',
  'mif1',
  'msf1',
]);
const AVIF_BRANDS = new Set(['avif', 'avis']);
const M4A_BRANDS = new Set(['M4A ', 'M4B ', 'M4P ', 'F4A ', 'F4B ']);
const QUICKTIME_BRANDS = new Set(['qt  ']);
const QUICKTIME_ATOMS = new Set(['moov', 'mdat', 'wide', 'free', 'skip']);

export function detectMediaContainer(prefix: Uint8Array): MediaContainer {
  const b = Buffer.from(prefix.buffer, prefix.byteOffset, prefix.byteLength);
  const at = (offset: number, ...bytes: number[]) =>
    b.length >= offset + bytes.length &&
    bytes.every((value, i) => b[offset + i] === value);
  const ascii = (offset: number, length: number) =>
    b.length >= offset + length
      ? b.toString('latin1', offset, offset + length)
      : '';

  if (at(0, 0xff, 0xd8, 0xff)) return 'jpeg';
  if (at(0, 0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a)) return 'png';
  if (ascii(0, 6) === 'GIF87a' || ascii(0, 6) === 'GIF89a') return 'gif';
  if (ascii(0, 4) === 'RIFF' && ascii(8, 4) === 'WEBP') return 'webp';
  if (ascii(4, 4) === 'ftyp') return isoBrand(b);
  if (QUICKTIME_ATOMS.has(ascii(4, 4))) return 'quicktime';
  if (ascii(0, 3) === 'ID3') return 'mp3';
  // MPEG audio frame sync: 11 set bits. Layer bits 00 mean ADTS (AAC).
  if (b.length >= 2 && b[0] === 0xff && (b[1]! & 0xe0) === 0xe0)
    return (b[1]! & 0x06) === 0 ? 'aac' : 'mp3';
  return 'unknown';
}

/** Whether the body's container is acceptable for the declared MIME. */
export function matchesDeclaredMime(
  declaredMime: string,
  prefix: Uint8Array,
): boolean {
  const accepted = ACCEPTED[declaredMime.split(';')[0]!.trim().toLowerCase()];
  return (
    accepted !== undefined && accepted.includes(detectMediaContainer(prefix))
  );
}

/** ISO-BMFF (`ftyp`): the major brand, then the compatible brands, decide. */
function isoBrand(b: Buffer): MediaContainer {
  const boxSize = b.readUInt32BE(0);
  const end = Math.min(b.length, boxSize >= 16 ? boxSize : 16);
  const brands = [b.toString('latin1', 8, 12)];
  for (let offset = 16; offset + 4 <= end; offset += 4)
    brands.push(b.toString('latin1', offset, offset + 4));
  const major = brands[0]!;
  // The major brand states the file's intended format; images are checked first
  // so a HEIF with an `iso8`/`mp42` compatible brand is never accepted as MP4.
  if (HEIF_BRANDS.has(major) || brands.some((x) => HEIF_BRANDS.has(x)))
    return AVIF_BRANDS.has(major) ? 'avif' : 'heif';
  if (AVIF_BRANDS.has(major) || brands.some((x) => AVIF_BRANDS.has(x)))
    return 'avif';
  if (M4A_BRANDS.has(major)) return 'm4a';
  if (QUICKTIME_BRANDS.has(major)) return 'quicktime';
  return 'mp4';
}

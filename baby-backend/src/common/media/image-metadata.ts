/**
 * Lossless metadata removal for originals kept at full quality (spec §10.3: remove
 * GPS without touching pixels). Entropy-coded image data is copied byte for byte.
 */

const JPEG_SOI = 0xffd8;
// APP0 (JFIF), APP2 (ICC profile) and APP14 (Adobe colour transform) affect decoding.
const JPEG_KEEP_APP = new Set([0xffe0, 0xffe2, 0xffee]);

/**
 * Drops EXIF/XMP/IPTC/comment segments of a JPEG. The EXIF orientation, which
 * affects display, is kept as a minimal EXIF block without any other tag.
 */
export function stripJpegMetadata(input: Buffer, orientation?: number): Buffer {
  if (input.length < 4 || input.readUInt16BE(0) !== JPEG_SOI)
    throw new Error('Not a JPEG file');
  const parts: Buffer[] = [input.subarray(0, 2)];
  let offset = 2;
  // EXIF APP1 goes right after SOI, or after APP0 when the file is JFIF.
  const jfif = input.length >= 4 && input.readUInt16BE(2) === 0xffe0;
  let insertedOrientation = !orientation || orientation === 1;
  if (!insertedOrientation && !jfif) {
    parts.push(orientationSegment(orientation!));
    insertedOrientation = true;
  }
  while (offset + 4 <= input.length) {
    const marker = input.readUInt16BE(offset);
    if ((marker & 0xff00) !== 0xff00) throw new Error('Corrupt JPEG');
    if (marker === 0xffda) {
      // Start of scan: the rest is image data.
      parts.push(input.subarray(offset));
      return Buffer.concat(parts);
    }
    const length = input.readUInt16BE(offset + 2);
    const end = offset + 2 + length;
    if (length < 2 || end > input.length) throw new Error('Corrupt JPEG');
    const isApp = marker >= 0xffe0 && marker <= 0xffef;
    const isComment = marker === 0xfffe;
    if ((!isApp && !isComment) || JPEG_KEEP_APP.has(marker))
      parts.push(input.subarray(offset, end));
    if (!insertedOrientation && marker === 0xffe0) {
      parts.push(orientationSegment(orientation!));
      insertedOrientation = true;
    }
    offset = end;
  }
  throw new Error('JPEG has no image data');
}

/** Single-tag EXIF APP1 (TIFF big-endian, IFD0 Orientation). */
function orientationSegment(orientation: number): Buffer {
  const payload = Buffer.alloc(6 + 8 + 2 + 12 + 4);
  payload.write('Exif\0\0', 0, 'latin1');
  payload.write('MM', 6, 'latin1');
  payload.writeUInt16BE(42, 8);
  payload.writeUInt32BE(8, 10); // IFD0 offset
  payload.writeUInt16BE(1, 14); // one entry
  payload.writeUInt16BE(0x0112, 16); // Orientation
  payload.writeUInt16BE(3, 18); // SHORT
  payload.writeUInt32BE(1, 20);
  payload.writeUInt16BE(orientation, 24);
  payload.writeUInt32BE(0, 28); // no next IFD
  const header = Buffer.alloc(4);
  header.writeUInt16BE(0xffe1, 0);
  header.writeUInt16BE(payload.length + 2, 2);
  return Buffer.concat([header, payload]);
}

const PNG_SIGNATURE = Buffer.from([
  0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a,
]);
const PNG_DROP = new Set(['tEXt', 'zTXt', 'iTXt', 'eXIf', 'tIME']);

/** Drops textual/EXIF/time chunks of a PNG; pixel data chunks are untouched. */
export function stripPngMetadata(input: Buffer): Buffer {
  if (!input.subarray(0, 8).equals(PNG_SIGNATURE))
    throw new Error('Not a PNG file');
  const parts: Buffer[] = [PNG_SIGNATURE];
  let offset = 8;
  while (offset + 12 <= input.length) {
    const length = input.readUInt32BE(offset);
    const type = input.toString('latin1', offset + 4, offset + 8);
    const end = offset + 12 + length;
    if (end > input.length) throw new Error('Corrupt PNG');
    if (!PNG_DROP.has(type)) parts.push(input.subarray(offset, end));
    offset = end;
    if (type === 'IEND') return Buffer.concat(parts);
  }
  throw new Error('PNG has no IEND chunk');
}

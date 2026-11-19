import {
  detectMediaContainer,
  matchesDeclaredMime,
} from '../../src/services/media-content-signature';

/** ISO-BMFF `ftyp` box with the given major and compatible brands. */
function ftyp(major: string, ...compatible: string[]): Buffer {
  const size = 16 + compatible.length * 4;
  const box = Buffer.alloc(size);
  box.writeUInt32BE(size, 0);
  box.write('ftyp', 4, 'latin1');
  box.write(major, 8, 'latin1');
  compatible.forEach((brand, i) => box.write(brand, 16 + i * 4, 'latin1'));
  return box;
}

describe('media content signature', () => {
  const jpeg = Buffer.from('ffd8ffe000104a464946', 'hex');
  const png = Buffer.from('89504e470d0a1a0a0000000d49484452', 'hex');
  const webp = Buffer.concat([
    Buffer.from('RIFF'),
    Buffer.alloc(4),
    Buffer.from('WEBPVP8 '),
  ]);
  const mp4 = ftyp('isom', 'isom', 'iso2', 'mp41');
  const m4a = ftyp('M4A ', 'M4A ', 'mp42', 'isom');
  const heic = ftyp('heic', 'mif1', 'heic');
  const mov = ftyp('qt  ', 'qt  ');

  it('detects containers from their magic bytes', () => {
    expect(detectMediaContainer(jpeg)).toBe('jpeg');
    expect(detectMediaContainer(png)).toBe('png');
    expect(detectMediaContainer(Buffer.from('GIF89a'))).toBe('gif');
    expect(detectMediaContainer(webp)).toBe('webp');
    expect(detectMediaContainer(mp4)).toBe('mp4');
    expect(detectMediaContainer(m4a)).toBe('m4a');
    expect(detectMediaContainer(heic)).toBe('heif');
    expect(detectMediaContainer(ftyp('avif', 'mif1', 'avif'))).toBe('avif');
    expect(detectMediaContainer(mov)).toBe('quicktime');
    expect(detectMediaContainer(Buffer.from('ID3\u0004'))).toBe('mp3');
    expect(detectMediaContainer(Buffer.from('fff15080', 'hex'))).toBe('aac');
    expect(detectMediaContainer(Buffer.from('plain text'))).toBe('unknown');
    expect(detectMediaContainer(Buffer.alloc(0))).toBe('unknown');
  });

  it('rejects a video or another image format declared as JPEG', () => {
    expect(matchesDeclaredMime('image/jpeg', jpeg)).toBe(true);
    expect(matchesDeclaredMime('image/jpeg', mp4)).toBe(false);
    expect(matchesDeclaredMime('image/jpeg', png)).toBe(false);
    expect(matchesDeclaredMime('image/jpeg', heic)).toBe(false);
    expect(matchesDeclaredMime('image/webp', webp)).toBe(true);
  });

  it('accepts MP4/M4A siblings but never an image as video', () => {
    expect(matchesDeclaredMime('video/mp4', mp4)).toBe(true);
    expect(matchesDeclaredMime('video/quicktime', mov)).toBe(true);
    expect(matchesDeclaredMime('audio/mp4', m4a)).toBe(true);
    expect(matchesDeclaredMime('audio/x-m4a', mp4)).toBe(true);
    expect(matchesDeclaredMime('video/mp4', heic)).toBe(false);
    expect(matchesDeclaredMime('video/mp4', jpeg)).toBe(false);
    expect(matchesDeclaredMime('video/mp4; codecs=avc1', mp4)).toBe(true);
  });

  it('rejects MIME types it does not know', () => {
    expect(matchesDeclaredMime('application/pdf', jpeg)).toBe(false);
  });
});

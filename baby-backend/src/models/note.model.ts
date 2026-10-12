export interface NoteAttributes {
  id: string;
  title: string;
  content: string | null;
  createdAt: Date;
  updatedAt: Date;
}

export class Note implements NoteAttributes {
  readonly id: string;
  readonly title: string;
  readonly content: string | null;
  readonly createdAt: Date;
  readonly updatedAt: Date;

  constructor(attributes: NoteAttributes) {
    this.id = attributes.id;
    this.title = attributes.title;
    this.content = attributes.content;
    this.createdAt = attributes.createdAt;
    this.updatedAt = attributes.updatedAt;
  }

  hasContent(): boolean {
    return this.content !== null && this.content.trim().length > 0;
  }
}

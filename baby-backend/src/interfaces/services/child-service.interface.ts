import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { UpdateChildDto } from '../../dto/child/update-child.dto';
import type { ChildResponseDto } from '../../dto/child/child-response.dto';
import type { CreateChildDto } from '../../dto/child/create-child.dto';
import type {
  Paginated,
  PaginationInput,
} from '../../common/pagination/pagination.types';

export const CHILD_SERVICE = Symbol('CHILD_SERVICE');
export interface IChildService {
  list(
    actor: AuthPrincipal,
    familyId: string,
    input: PaginationInput,
  ): Promise<Paginated<ChildResponseDto>>;
  getById(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
  ): Promise<ChildResponseDto>;
  create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateChildDto,
  ): Promise<ChildResponseDto>;
  update(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: UpdateChildDto,
  ): Promise<ChildResponseDto>;
}

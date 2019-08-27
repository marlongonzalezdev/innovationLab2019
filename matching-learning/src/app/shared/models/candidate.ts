import {DeliveryUnit} from './deliveryUnit';
import {RolesHistory} from './rolesHistory';
import {ActiveRole} from './activeRole';

export interface Candidate {
  id: number;
  firstName: string;
  lastName: string;
  name: string;
  deliveryUnitId: number;
  deliveryUnit: DeliveryUnit;
  relationType: number;
  inBench: boolean;
  docType: number;
  docNumber: string;
  employeeNumber: number;
  rolesHistory: RolesHistory[];
  activeRole: ActiveRole;
  picture: string;
  isActive: boolean;
  
}

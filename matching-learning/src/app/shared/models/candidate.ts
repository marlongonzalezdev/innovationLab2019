import {DeliveryUnit} from './deliveryUnit';

import {Role} from './role';
import {Evaluation} from './evaluation';

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
  candidateRoleId: number;
  candidateRole: Role;
  picture: string;
  isActive: boolean;
  gradeDescription: string;
  currentProjectDescription: string;
  currentProjectDuration: string;	  
  evaluations: Evaluation[];
}

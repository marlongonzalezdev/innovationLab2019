import {DeliveryUnit} from './deliveryUnit';

import {ActiveRole} from './activeRole';
import {Evaluation} from './evaluation';
import {CandidateRolHistory} from './rolesHistory';

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
  candidateRolHistory: CandidateRolHistory[];
  activeRole: ActiveRole;
  picture: string;
  isActive: boolean;
  evaluations: Evaluation[];
}

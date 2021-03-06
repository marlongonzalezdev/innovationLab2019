import {DeliveryUnit} from './deliveryUnit';

import {Role} from './role';
import {Evaluation} from './evaluation';
import {Project} from './project';

export interface Candidate {
  id: number;
  deliveryUnitId: number;
  deliveryUnit: DeliveryUnit;
  relationType: number;
  firstName: string;
  lastName: string;
  name: string;
  candidateRoleId: number;
  candidateRole: Role;
  grade: number;
  inBench: boolean;
  docType: number;
  docNumber: string;
  employeeNumber: number;
  project: Project;
  currentProjectId: number;
  CurrentProjectJoin: Date;

  picture: string;
  isActive: boolean;
  gradeDescription: string;
  currentProjectDescription: string;
  currentProjectDuration: string;
  evaluations: Evaluation[];
}

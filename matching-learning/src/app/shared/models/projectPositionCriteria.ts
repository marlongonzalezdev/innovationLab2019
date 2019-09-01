import {SkillsFilter} from './skillsFilter';

export interface ProjectPositionCriteria {
  max: number;
  name: string;
  skillsFilter: SkillsFilter[];
  roleIdFilter: number;
  deliveryUnitIdFilter: number;
  inBenchFilter: boolean;
  relationTypeFilter: number;
}




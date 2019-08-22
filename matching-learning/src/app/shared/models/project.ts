import {SkillsFilter} from './skillsFilter';

export interface Project {
  max: number;
  name: string;
  skillsFilter: SkillsFilter[];
  roleIdFilter: number;
  deliveryUnitIdFilter: number;
  inBenchFilter: boolean;
  relationTypeFilter: number;
}




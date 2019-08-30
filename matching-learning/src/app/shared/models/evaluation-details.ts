import {Skill} from './skill';

export interface EvaluationDetails {
  id: number;
  skillId: number;
  skill: Skill;
  expertise: number;
}

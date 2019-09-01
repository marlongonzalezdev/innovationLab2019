import {Skill} from './skill';

export interface EvaluationDetails {
  id: number;
  evaluationId: number;
  skillId: number;
  expertise: number;
  skill: Skill;
}

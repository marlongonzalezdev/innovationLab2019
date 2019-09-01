import { EvaluationDetails } from './evaluation-details';
import {EvaluationType} from './evaluation-type';
import {Skill} from './skill';


export interface Evaluation {
   id: number;
   candidateId: number;
   evaluationType: EvaluationType;
   evaluationTypeId: number;
   date: Date;
   details: EvaluationDetails[];
   notes: string;
}

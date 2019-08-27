import {Candidate} from './candidate';
import {EvaluationType} from './evaluation-type';


export interface Evaluation {
   id: number;
   candidateId: number;
   evaluationType: EvaluationType;
   date: Date;
}

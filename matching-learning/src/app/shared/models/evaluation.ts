import {Candidate} from './candidate';
import {EvaluationType} from './evaluation-type';


export interface Evaluation {
   id: number;
   candidateId: number;
   candidate: Candidate;
   evaluationType: EvaluationType;
   date: Date;
}

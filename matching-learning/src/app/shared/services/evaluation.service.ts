import { Injectable } from '@angular/core';
import {HttpClient, HttpErrorResponse, HttpHeaders} from '@angular/common/http';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {Observable, throwError} from 'rxjs';
import {Candidate} from '../models/candidate';
import {EvaluationType} from '../models/evaluation-type';
import {Evaluation} from '../models/evaluation';
import {environment} from '../../../environments/environment';
import {catchError} from 'rxjs/operators';

const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type': 'application/json',
    Authorization: 'my-auth-token'
  })
};

@Injectable({
  providedIn: 'root'
})
export class EvaluationService {

   url: string;

  constructor(private http: HttpClient) { }

  form: FormGroup = new FormGroup({
    $key: new FormControl(-1),
    candidateId: new FormControl(''),
    weight: new FormControl(0, Validators.required),
    evaluationTypeId: new FormControl(0, Validators.required),
    skillId: new FormControl(0, Validators.required),
    notes: new FormControl(''),
    evaluationDetails: new FormControl(''),
    date: new FormControl('')
  });

  InitializeFormGroup() {
    this.form.setValue({
      $key: null,
      candidateId: null,
      weight: 0,
      evaluationTypeId: 0,
      skillId: 0,
      notes: '',
      evaluationDetails: '',
      date: ''
    });
  }

  PopulateForm(evaluation) {
    this.form.setValue({
      $key: evaluation.id,
      candidateId: evaluation.candidateId,
      weight: 0,
      evaluationTypeId: evaluation.evaluationTypeId,
      skillId: 0,
      notes: evaluation.notes,
      evaluationDetails: evaluation.details,
      date: evaluation.date
    });
  }

  getEvaluations(id): Observable<Candidate> {
    this.url = `https://localhost:44374/Candidates/Candidate?id=${id}`;
    return this.http.get<Candidate>(this.url, {responseType: 'json'});
  }

  getEvaluationTypes(): Observable<EvaluationType[]> {
    this.url = 'https://localhost:44374/Evaluations/EvaluationTypes';
    return this.http.get<EvaluationType[]>(this.url, {responseType: 'json'});
  }

  addEvaluation(evaluation: Evaluation): Observable<Evaluation> {
    this.url = 'https://localhost:44374/Evaluations/SaveEvaluation';
    return this.http.post<Evaluation>(this.url, evaluation, httpOptions)
      .pipe(
        catchError(this.handleError)
      );
  }

  private handleError(error: HttpErrorResponse) {
    if (error.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      console.error('An error occurred:', error.error.message);
    } else {
      // The backend returned an unsuccessful response code.
      // The response body may contain clues as to what went wrong,
      console.error(
        `Backend returned code ${error.status}, ` +
        `body was: ${error.error}`);
    }
    // return an observable with a user-facing error message
    return throwError(
      'Something bad happened; please try again later.');
  }
}

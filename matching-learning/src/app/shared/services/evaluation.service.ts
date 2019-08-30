import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {Observable} from 'rxjs';
import {Candidate} from '../models/candidate';
import {EvaluationType} from '../models/evaluation-type';

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
    candidateName: new FormControl(''),
    notes: new FormControl('')
  });

  InitializeFormGroup() {
    this.form.setValue({
      $key: -1,
      candidateId: null,
      weight: 0,
      evaluationTypeId: 0,
      skillId: 0,
      candidateName: '',
      notes: ''
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
}

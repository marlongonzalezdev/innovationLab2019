import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {Observable} from 'rxjs';
import {Candidate} from '../models/candidate';
import {environment} from '../../../environments/environment';
import {Evaluation} from '../models/evaluation';

@Injectable({
  providedIn: 'root'
})
export class EvaluationService {

   url: string;

  constructor(private http: HttpClient) { }

  form: FormGroup = new FormGroup({
    $key: new FormControl(null),
    candidateId: new FormControl(''),
    evaluationType: new FormControl(0, Validators.required),
    skills: new FormControl(0, Validators.required),
    candidateName: new FormControl('')
  });

  InitializeFormGroup() {
    this.form.setValue({
      $key: -1,
      candidateId: null,
      evaluationType: 0,
      skills: 0,
      candidateName: ''
    });
  }

  getEvaluations(id): Observable<Evaluation[]> {
    this.url = 'https://localhost:44374/Evaluations/Evaluation?id=22';
    return this.http.get<Evaluation[]>(this.url, {responseType: 'json'});
  }
}

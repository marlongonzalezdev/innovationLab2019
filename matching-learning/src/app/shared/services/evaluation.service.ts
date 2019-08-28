import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {Observable} from 'rxjs';
import {Candidate} from '../models/candidate';

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
    evaluationType: new FormControl(0, Validators.required),
    skills: new FormControl(0, Validators.required),
    candidateName: new FormControl('')
  });

  InitializeFormGroup() {
    this.form.setValue({
      $key: -1,
      candidateId: null,
      weight: 0,
      evaluationType: 0,
      skills: 0,
      candidateName: ''
    });
  }

  getEvaluations(id): Observable<Candidate> {
    this.url = `https://localhost:44374/Candidates/Candidate?id=${id}`;
    return this.http.get<Candidate>(this.url, {responseType: 'json'});
  }
}

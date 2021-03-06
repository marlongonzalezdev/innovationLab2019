import { Injectable } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { HttpHeaders } from '@angular/common/http';

import { Candidate } from '../models/candidate';
import { environment } from 'src/environments/environment';
import {Role} from '../models/role';
import {CandidateGrade} from '../models/candidate-grade';


const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type': 'application/json',
    Authorization: 'my-auth-token'
  })
};


@Injectable({
  providedIn: 'root'
})
export class CandidateService {
  url: string;


  constructor(private http: HttpClient) { }

  form: FormGroup = new FormGroup({
    $key: new FormControl(null),
    name: new FormControl(''),
    firstName: new FormControl('', Validators.required),
    lastName: new FormControl('', Validators.required),
    du: new FormControl(0),
    relationType: new FormControl(0),
    roleId: new FormControl(0),
   /* email: new FormControl('', Validators.email),
    gender: new FormControl(0),*/
    isActive: new FormControl(false),
    isInBench: new FormControl(false),
    project: new FormControl(false),
    grade: new FormControl(false),
    date: new FormControl(new Date())
  });

  InitializeFormGroup() {
    this.form.setValue({
      $key: -1,
      name: '',
      firstName: '',
      lastName: '',
      du: 13, // Montevideo
      relationType: 0,
      roleId: 0,
      isActive: true,
      isInBench: false,
      project: null,
      grade: null,
      date: new Date()
    });
  }

  getCandidates(): Observable<Candidate[]> {
    this.url = environment.dbConfig.baseUrl + environment.dbConfig.GetCandidates;
    return this.http.get<Candidate[]>(this.url, {responseType: 'json'});
  }

  getCandidateRoles(): Observable<Role[]> {
    this.url = 'https://localhost:44374/Candidates/CandidateRoles';
    return this.http.get<Role[]>(this.url, {responseType: 'json'});
  }

  getCandidateById(id): Observable<Candidate> {
    this.url = `https://localhost:44374/Candidates/Candidate?id=${id}`;
    return this.http.get<Candidate>(this.url, {responseType: 'json'});
  }

  addCandidate(candidate: Candidate): Observable<Candidate> {
   this.url = environment.dbConfig.baseUrl + environment.dbConfig.AddCandidate;
   return this.http.post<Candidate>(this.url, candidate, httpOptions)
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

  populateForm(candidate) {
    this.form.setValue({
      $key: candidate.id,
      name: '',
      firstName: candidate.firstName,
      lastName: candidate.lastName,
      du: candidate.deliveryUnitId,
      relationType: candidate.relationType,
      isActive: candidate.isActive,
      isInBench: candidate.inBench,
      roleId: candidate.candidateRoleId,
      project: candidate.currentProjectId,
      grade: candidate.grade,
      date: candidate.currentProjectJoin
    });
  }

  getGrades() {
    this.url = environment.dbConfig.baseUrl + environment.dbConfig.GetCandiGrades;
    return this.http.get<CandidateGrade[]>(this.url, {responseType: 'json'});
  }
}

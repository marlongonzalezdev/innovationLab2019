import { Injectable } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { HttpHeaders } from '@angular/common/http';

import { Candidate } from '../candidate';
import { environment } from 'src/environments/environment';


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
    name: new FormControl('', Validators.required),
    lastName: new FormControl('', Validators.required),
    du: new FormControl(0),
    relationType: new FormControl(0),
    email: new FormControl('', Validators.email),
    gender: new FormControl(0),
    isInternal: new FormControl(false),
    isInBench: new FormControl(false)
  });

  InitializeFormGroup() {
    this.form.setValue({
      $key: null,
      name: '',
      lastName: '',
      du: 0,
      relationType: 0,
      email: '',
      gender: 0,
      isInternal: false,
      isInBench: false
    });
  }

  getWriterWithFavBooks(): Observable<Candidate> {
    this.url = environment.dbConfig.baseUrl + environment.dbConfig.GetCandidates;
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
}

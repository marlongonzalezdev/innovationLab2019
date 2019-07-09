import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { HandleError, HttpErrorHandler } from './http-error-handler.service';
import { Project } from './project';
import { Match } from './match';
import { catchError } from 'rxjs/operators';


const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type':  'application/json',
    'Authorization': 'my-auth-token'
  })
};

@Injectable({
  providedIn: 'root'
})
export class MatchService {
  matchesUrl = 'https://localhost:44374/Project/candidates';  // URL to web api
  private handleError: HandleError;

  constructor(
    private http: HttpClient,
    httpErrorHandler: HttpErrorHandler) {
    this.handleError = httpErrorHandler.createHandleError('MatchService');
  }

  getMatches(project: Project): Observable<{matches:Match[]}> {
    return this.http.post<{matches:Match[]}>(this.matchesUrl, project, httpOptions)
    .pipe(
      catchError(this.handleError<{matches:Match[]}>('getMatches', {matches:[]}))
    );    
  }


  // getMatches(): Observable<User[]> {
  //   return of(Users);
  // }
 
}

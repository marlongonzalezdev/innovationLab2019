import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { HandleError, HttpErrorHandler } from './http-error-handler.service';

import { catchError } from 'rxjs/operators';
import { Project } from './shared/models/project';
import { Match } from './shared/models/match';


const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type':  'application/json',
    Authorization: 'my-auth-token'
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

  getMatches(project: Project): Observable<{matches: Match[]}> {
    return this.http.post<{matches: Match[]}>(this.matchesUrl, project, httpOptions)
    .pipe(
      catchError(this.handleError<{matches: Match[]}>('getMatches', {matches: []}))
    );
  }
}

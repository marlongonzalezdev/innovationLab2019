import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { HandleError, HttpErrorHandler } from '../../http-error-handler.service';

import { catchError } from 'rxjs/operators';
import { ProjectPositionCriteria } from '../models/projectPositionCriteria';
import { Match } from '../models/match';
import {environment} from '../../../environments/environment';


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

  matchesUrl = 'https://localhost:44374/Projects/GetProjectCandidates';
  private readonly handleError: HandleError;

  constructor(
    private http: HttpClient,
    httpErrorHandler: HttpErrorHandler) {
    this.handleError = httpErrorHandler.createHandleError('MatchService');
  }

  getMatches(projectPositionCriteria: ProjectPositionCriteria): Observable<Match[]> {
    return this.http.post<Match[]>(this.matchesUrl, projectPositionCriteria, httpOptions)
      .pipe(
       /* catchError(this.handleError<Match[]>('getMatches', {matches: []}))*/
      );
  }
}

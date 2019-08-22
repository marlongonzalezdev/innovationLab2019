import { HttpErrorHandler, HandleError } from './../../../http-error-handler.service';
import { Skill } from '../../../shared/models/skill';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { Observable } from 'rxjs';
import { catchError } from 'rxjs/operators';
import {SkillServiceBase} from './skill-service-base';

const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type':  'application/json',
    Authorization: 'my-auth-token'
  })
};
@Injectable({
  providedIn: 'root'
})
export class SkillService implements SkillServiceBase {
    constructor(
    private http: HttpClient, httpErrorHandler: HttpErrorHandler
  ) { this.handleError = httpErrorHandler.createHandleError('SkillService');  }
  baseUrl = 'https://localhost:44374';
  private handleError: HandleError;

  getSkills(): Observable<Skill[]> {
    const route = '/Skills/Skills';
    return this.http.get<Skill[]>(`${this.baseUrl}${route}`, httpOptions)
    .pipe(
      catchError(this.handleError<Skill[]>('getSkill', []))
    );
  }
  getSkillById(skill: Skill): Observable<Skill> {
      const route = `'/Skills/Skill?id='${skill.id}`;
      return this.http.get<Skill>(`${this.baseUrl}${route}`);
  }

}

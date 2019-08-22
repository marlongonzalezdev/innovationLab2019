import { SkillCategory } from './../../../models/skill-category';
import { HttpErrorHandler, HandleError } from './../../../http-error-handler.service';
import { Skills } from '../../../models/skills';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { SkillServiceBase } from './skill-servie-base';
import { Observable } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { FormGroup, FormControl, Validators } from '@angular/forms';

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

  form = new FormGroup({
    $key: new FormControl(null),
    name: new FormControl('', Validators.required),
    category: new FormControl('', Validators.required),
    isVersioned: new FormControl(false)
  });

  getSkill(): Observable<Skills[]> {
    const route = '/Skills/Skills';
    return this.http.get<Skills[]>(`${this.baseUrl}${route}`, httpOptions)
    .pipe(
      catchError(this.handleError<Skills[]>('getSkill', []))
    );
  }
  getSkillById(Skill: Skills): Observable<Skills> {
      const route = `'/Skills/Skill?id='${Skill.id}`;
      return this.http.get<Skills>(`${this.baseUrl}${route}`);
  }
   getSkillCategory(): Observable<SkillCategory>{
    const route = '/EnumEntities/SkillCategories';
    return this.http.get<SkillCategory>(`${this.baseUrl}${route}`, httpOptions)
    .pipe(
      catchError(this.handleError<SkillCategory>('getSkillCategory'))
    );
  }
}

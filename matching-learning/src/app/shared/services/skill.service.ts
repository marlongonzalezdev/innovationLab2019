import { SkillCategory } from '../models/skill-category';
import { HttpErrorHandler, HandleError } from '../../http-error-handler.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { Observable } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import {SkillServiceBase} from './skill-service-base';
import { Skill } from '../models/skill';

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
    isVersioned: new FormControl(false),
    versions: new FormControl('')
  });

  getSkillsSorted(): Observable<Skill[]> {
    const route = '/Skills/SkillsSorted';
    return this.http.get<Skill[]>(`${this.baseUrl}${route}`, httpOptions)
    .pipe(
      catchError(this.handleError<Skill[]>('getSkill', []))
    );
  } 
  getSkills(): Observable<Skill[]> {
    const route = '/Skills/SkillViews';
    return this.http.get<Skill[]>(`${this.baseUrl}${route}`, httpOptions)
    .pipe(
      catchError(this.handleError<Skill[]>('getSkill', []))
    );
  }
  getSkillById(skill: Skill): Observable<Skill> {
      const route = `'/Skills/Skill?id='${skill.id}`;
      return this.http.get<Skill>(`${this.baseUrl}${route}`);
  }
   getSkillCategory(): Observable<SkillCategory> {
    const route = '/EnumEntities/SkillCategories';
    return this.http.get<SkillCategory>(`${this.baseUrl}${route}`, httpOptions)
    .pipe(
      catchError(this.handleError<SkillCategory>('getSkillCategory'))
    );
  }
   saveSkill(skill: Skill): Observable<Skill> {
     const route = '/Skills/SaveSkillView';
     return this.http.post<Skill>(`${this.baseUrl}${route}`, skill, httpOptions)
     .pipe(
       catchError(this.handleError<Skill>('saveSkill'))
     );
   }

   initializeFormGroup() {
    this.form.setValue({
      $key: null,
      name: '',
      category: '',
      isVersioned: false,
      versions: []
    });
  }

  populateForm(skill) {
    this.form.setValue({
      $key: skill.id,
      name: skill.name,
      category: skill.category,
      isVersioned: skill.isVersioned,
      versions: skill.versions
    });
  }
}

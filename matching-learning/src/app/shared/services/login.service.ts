import { LoginComponent } from './../../components/login/login.component';
import { LoginData } from './../models/loginData';
import { catchError } from 'rxjs/operators';
import { HttpErrorHandler, HandleError } from './../../http-error-handler.service';
import { AuthenticatedUser } from './../models/authenticatedUser';
import { Injectable } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { Observable } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';

const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type':  'application/json',
    Authorization: 'my-auth-token'
  })
};
@Injectable({
  providedIn: 'root'
})
export class LoginService {

  constructor(private http: HttpClient, httpErrorHandler: HttpErrorHandler) {
    this.handleError = httpErrorHandler.createHandleError('SkillService');
   }

   private handleError: HandleError;
   baseUrl = 'https://localhost:44374';
   loginForm = new FormGroup ({
    user: new FormControl('', Validators.required),
    password: new FormControl('', Validators.required)
  });

  getUserAuthenticated(data: LoginData): Observable<AuthenticatedUser> {
    const route = '/Login/Login';
    return this.http.post<LoginData>(`${this.baseUrl}${route}`, data, httpOptions)
    .pipe(
      catchError(this.handleError<LoginData>('getUserAuthenticated'))
    );
  }

}

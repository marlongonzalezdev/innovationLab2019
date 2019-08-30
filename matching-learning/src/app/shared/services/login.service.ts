import { LoginComponent } from './../../components/login/login.component';
import { LoginData } from './../models/loginData';
import { catchError, map } from 'rxjs/operators';
import { HttpErrorHandler, HandleError } from './../../http-error-handler.service';
import { AuthenticatedUser } from './../models/authenticatedUser';
import { Injectable } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { Observable, BehaviorSubject } from 'rxjs';
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
  private currentUserSubject: BehaviorSubject<LoginData>;
  public currentUser: Observable<LoginData>;
  constructor(private http: HttpClient, httpErrorHandler: HttpErrorHandler) {
    this.handleError = httpErrorHandler.createHandleError('SkillService');
    this.currentUserSubject = new BehaviorSubject<LoginData>(JSON.parse(localStorage.getItem('currentUser')));
    this.currentUser = this.currentUserSubject.asObservable();
   }

   private handleError: HandleError;
   baseUrl = 'https://localhost:44374';
   loginForm = new FormGroup ({
    user: new FormControl('', Validators.required),
    password: new FormControl('', Validators.required)
  });
  public get currentUserValue(): LoginData {
    return this.currentUserSubject.value;
  }
  getUserAuthenticated(data: LoginData): Observable<LoginData> {
    const route = '/Login/Login';
    return this.http.post<LoginData>(`${this.baseUrl}${route}`, data, httpOptions)
    .pipe(
      map(loginData => {
        let user: LoginData;
        if (loginData.authenticated) {
            user = {
             userName: data.userName,
             password: data.password,
             authenticated: loginData.authenticated,
             message: loginData.message
           };
            localStorage.setItem('currentUser', JSON.stringify(user));
            this.currentUserSubject.next(user);
        } else {
          user = {
            userName: data.userName,
            password: data.password,
            authenticated: loginData.authenticated,
            message: loginData.message
          };
        }
        return user;
      }),
      catchError(this.handleError<LoginData>('getUserAuthenticated'))
    );
  }
  logout() {
    // remove user from local storage to log user out
    localStorage.removeItem('currentUser');
    this.currentUserSubject.next(null);
    this.loginForm.reset();
}
}

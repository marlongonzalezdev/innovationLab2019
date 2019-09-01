import {Injectable} from '@angular/core';
import {FormControl, FormGroup} from '@angular/forms';
import {HttpClient, HttpErrorResponse} from '@angular/common/http';
import {Observable, throwError} from 'rxjs';
import {catchError} from 'rxjs/operators';
import {HttpHeaders} from '@angular/common/http';

import {environment} from 'src/environments/environment';
import {Project} from '../models/project';


const httpOptions = {
    headers: new HttpHeaders({
        'Content-Type': 'application/json',
        Authorization: 'my-auth-token'
    })
};


@Injectable({
    providedIn: 'root'
})
export class ProjectService {
    url: string;


    constructor(private http: HttpClient) {
    }

    form: FormGroup = new FormGroup({
        $key: new FormControl(null),
        code: new FormControl(''),
        name: new FormControl('')
    });

    InitializeFormGroup() {
        this.form.setValue({
            $key: -1,
            code: '',
            name: ''
        });
    }

    getProjects(): Observable<Project[]> {
        this.url = environment.dbConfig.baseUrl + environment.dbConfig.GetProjects;
        return this.http.get<Project[]>(this.url, {responseType: 'json'});
    }

    addProject(project: Project): Observable<Project> {
        this.url = environment.dbConfig.baseUrl + environment.dbConfig.AddProject;
        return this.http.post<Project>(this.url, project, httpOptions)
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

    populateForm(project) {
        this.form.setValue({
            $key: project.id,
            code: project.code,
            name: project.name,
        });
    }
}

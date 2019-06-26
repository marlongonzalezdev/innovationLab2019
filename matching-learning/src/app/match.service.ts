import { Injectable } from '@angular/core';
import { Users } from './mock-users';
import { User } from './user';
import { Observable, of } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MatchService {

  getMatches(): Observable<User[]> {
    return of(Users);
  }
  constructor() { }
}

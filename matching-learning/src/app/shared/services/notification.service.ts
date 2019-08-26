import { Injectable } from '@angular/core';
import {MatSnackBar, MatSnackBarConfig} from '@angular/material';

@Injectable({
  providedIn: 'root'
})
export class NotificationService {

  constructor(public snackBar: MatSnackBar) { }

  config: MatSnackBarConfig =
  {
    duration: 3000,
    horizontalPosition: 'right',
    verticalPosition: 'top'
  };

  sucess(message: string) {
    this.config.panelClass = ['notification', 'success'];
    this.snackBar.open(message, '', this.config);
  }

  fail(message: string) {
    this.config.panelClass = ['notification', 'error'];
    this.snackBar.open(message, '', this.config);
  }
}

import {Component, OnInit, Input, Inject} from '@angular/core';
import {Match} from '../../shared/models/match';
import {MAT_DIALOG_DATA, MatDialogRef} from '@angular/material';
import {Candidate} from '../../shared/models/candidate';


@Component({
  selector: 'app-user-details',
  templateUrl: './user-details.component.html',
  styleUrls: ['./user-details.component.css']
})
export class UserDetailsComponent implements OnInit {
  // @Input() match: Match;
  constructor(public dialogRef: MatDialogRef<UserDetailsComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any) {
  }

  ngOnInit() {
  }
}

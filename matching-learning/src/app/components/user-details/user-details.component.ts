import { Component, OnInit, Input } from '@angular/core';
import {Match} from '../../shared/models/match';


@Component({
  selector: 'app-user-details',
  templateUrl: './user-details.component.html',
  styleUrls: ['./user-details.component.css']
})
export class UserDetailsComponent implements OnInit {
  @Input() match: Match;
  constructor() { }

  ngOnInit() {
  }

}

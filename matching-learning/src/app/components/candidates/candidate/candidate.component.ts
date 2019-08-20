import { Component, OnInit } from '@angular/core';
import {CandidateService} from '../../../shared/candidate.service';

@Component({
  selector: 'app-candidate',
  templateUrl: './candidate.component.html',
  styleUrls: ['./candidate.component.css']
})
export class CandidateComponent implements OnInit {

  constructor(private service: CandidateService) { }


  ngOnInit() {
  }

}

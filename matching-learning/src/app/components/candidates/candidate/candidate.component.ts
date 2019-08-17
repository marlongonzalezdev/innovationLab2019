import { Component, OnInit } from '@angular/core';
import {CandidateService} from '../../../shared/candidate.service';

@Component({
  selector: 'app-candidate',
  templateUrl: './candidate.component.html',
  styleUrls: ['./candidate.component.css']
})
export class CandidateComponent implements OnInit {

  constructor(private service: CandidateService) { }

  deliveryUnits = [{ id: 1, value: 'Dep 1' },
    { id: 2, value: 'Dep 2' },
    { id: 3, value: 'Dep 3' }];

  ngOnInit() {
  }

}

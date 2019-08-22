import { Component, OnInit } from '@angular/core';
import { CandidateService } from 'src/app/shared/services/candidate.service';
import { Candidate } from 'src/app/shared/models/candidate';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-candidate-list',
  templateUrl: './candidate-list.component.html',
  styleUrls: ['./candidate-list.component.css']
})
export class CandidateListComponent implements OnInit {

  candidates: Observable<Candidate[]>;

  constructor(private candidateService: CandidateService) { }

  ngOnInit() {
    this.getCandidates();
  }

  getCandidates() {
    this.candidates = this.candidateService.getCandidates();
  }
}

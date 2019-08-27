import {Component, Input, OnDestroy, OnInit} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {EvaluationService} from '../../../shared/services/evaluation.service';
import {Candidate} from '../../../shared/models/candidate';
import {Evaluation} from '../../../shared/models/evaluation';
import {MatTableDataSource} from '@angular/material';

@Component({
  selector: 'app-evaluation-list',
  templateUrl: './evaluation-list.component.html',
  styleUrls: ['./evaluation-list.component.css']
})
export class EvaluationListComponent implements OnInit, OnDestroy {
  id: number;
  private sub: any;
  evaluations: Evaluation[] = [];

  constructor(private route: ActivatedRoute, private  evaluationService: EvaluationService) {}

  ngOnInit() {
    this.sub = this.route.params.subscribe(params => {
      this.id = +params.id; // (+) converts string 'id' to a number
      console.log(this.id);
      this.evaluationService.getEvaluations(this.id)
        .subscribe(response => {
          this.evaluations = response;
          // this.dataSource = new MatTableDataSource<Candidate>(this.candidates);
          // this.dataSource.sort = this.sort;
          // this.dataSource.paginator = this.paginator;
          console.log(this.evaluations);
        });
    });
  }

  ngOnDestroy() {
    this.sub.unsubscribe();
  }
}

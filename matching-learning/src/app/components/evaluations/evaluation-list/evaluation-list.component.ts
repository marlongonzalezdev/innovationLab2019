import {Component, Input, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {EvaluationService} from '../../../shared/services/evaluation.service';
import {Evaluation} from '../../../shared/models/evaluation';
import {MatDialog, MatPaginator, MatSort, MatTableDataSource} from '@angular/material';
import {Candidate} from '../../../shared/models/candidate';

@Component({
  selector: 'app-evaluation-list',
  templateUrl: './evaluation-list.component.html',
  styleUrls: ['./evaluation-list.component.css']
})
export class EvaluationListComponent implements OnInit, OnDestroy {
  id: number;
  private sub: any;
  candidate: Candidate;

  dataSource: any;
  displayedColumns: string[] = ['evaluationType', 'expertise', 'date', 'actions'];
  searchKey: string;
  @ViewChild(MatSort, {static: false}) sort: MatSort;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;

  constructor(private route: ActivatedRoute, private  evaluationService: EvaluationService, private dialog: MatDialog) {}

  ngOnInit() {
    this.sub = this.route.params.subscribe(params => {
      this.id = +params.id; // (+) converts string 'id' to a number
      console.log(this.id);
      this.evaluationService.getEvaluations(this.id)
        .subscribe(response => {
          this.candidate = response;
          this.dataSource = new MatTableDataSource<Evaluation>(this.candidate.evaluations);
          // this.dataSource.sort = this.sort;
          // this.dataSource.paginator = this.paginator;
          console.log(this.candidate);
        });
    });
  }

  ngOnDestroy() {
    this.sub.unsubscribe();
  }

  onEdit(row: any) {
  }
}

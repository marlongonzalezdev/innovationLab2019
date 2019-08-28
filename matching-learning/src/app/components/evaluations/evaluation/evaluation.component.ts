import { Component, OnInit } from '@angular/core';
import {EvaluationService} from '../../../shared/services/evaluation.service';
import {MatDialogRef} from '@angular/material';
import {Evaluation} from '../../../shared/models/evaluation';
import {Skill} from '../../../shared/models/skill';

@Component({
  selector: 'app-evaluation',
  templateUrl: './evaluation.component.html',
  styleUrls: ['./evaluation.component.css']
})
export class EvaluationComponent implements OnInit {

  skills: Skill[] = [];
  constructor(private evaluationService: EvaluationService, public dialogRef: MatDialogRef<EvaluationComponent>) { }

  ngOnInit() {
  }

  onSubmit() {
    if (this.evaluationService.form.valid) {
      const evaluation: Evaluation = {
        id: -1,
        candidateId: this.evaluationService.form.controls.candidateId.value,
        date: new Date(),
        evaluationType: this.evaluationService.form.controls.evaluationType.value,
        // deliveryUnitId: 13,
        // deliveryUnit: null,
        // relationType: 1,
        // firstName: 'Juan',
        // lastName: 'Perez',
        // name: '',
        // activeRole: null,
        // rolesHistory: null,
        // docType: null,
        // docNumber: null,
        // employeeNumber: 43245,
        // inBench: true,
        // picture: null,
        // isActive: true, evaluations: null
      };

      // this.service.addCandidate(candidate).subscribe(
      //   elem => {
      //     this.notificationService.sucess('Candidate saved successfully.');
      //     this.onClear();
      //     console.log(elem);
      //     this.onClose();
      //   }
      // );
    }
  }

  onClose() {
    this.onClear();
    this.dialogRef.close();
  }

  private onClear() {
    this.evaluationService.form.reset();
    this.evaluationService.InitializeFormGroup();
  }
}

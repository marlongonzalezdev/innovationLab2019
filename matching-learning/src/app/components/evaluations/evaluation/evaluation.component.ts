import {EvaluationDetails} from './../../../shared/models/evaluation-details';
import {Component, Inject, OnInit} from '@angular/core';
import {EvaluationService} from '../../../shared/services/evaluation.service';
import {MAT_DIALOG_DATA, MatDialogRef, MatOption, MatSelectChange} from '@angular/material';
import {Evaluation} from '../../../shared/models/evaluation';
import {Skill} from '../../../shared/models/skill';
import {Observable} from 'rxjs';
import {EvaluationType} from '../../../shared/models/evaluation-type';
import {SkillService} from '../../../shared/services/skill.service';
import {NotificationService} from '../../../shared/services/notification.service';

@Component({
  selector: 'app-evaluation',
  templateUrl: './evaluation.component.html',
  styleUrls: ['./evaluation.component.css']
})
export class EvaluationComponent implements OnInit {

  evaluationTypes: Observable<EvaluationType[]>;
  skillsList: Skill[];
  skillName: string;
  skillsWithEvaluation: EvaluationDetails[];
  evaluationDisable: boolean;

  constructor(public evaluationService: EvaluationService, private skillService: SkillService,
              private notificationService: NotificationService,
              public dialogRef: MatDialogRef<EvaluationComponent>, @Inject(MAT_DIALOG_DATA) private data: any) {
  }

  ngOnInit() {
    this.skillsWithEvaluation = this.evaluationService.form.controls.evaluationDetails.value ?
      this.evaluationService.form.controls.evaluationDetails.value : this.skillsWithEvaluation = [];
    this.evaluationTypes = this.evaluationService.getEvaluationTypes();
    this.skillService.getSkills()
      .subscribe(response => {
        this.skillsList = response;
      });
    if (this.evaluationService.form.controls.$key.value) {
      this.evaluationDisable = true;
    } else {
      this.evaluationDisable = false;
    }

  }

  onSubmit() {
    if (this.evaluationService.form.valid) {
      const evaluation: Evaluation = {
        id: -1,
        candidateId: this.data.id,
        date: new Date(),
        evaluationType: null,
        evaluationTypeId: this.evaluationService.form.controls.evaluationTypeId.value,
        details: this.skillsWithEvaluation,
        notes: this.evaluationService.form.controls.notes.value,
      };

      console.log(evaluation);

      this.evaluationService.addEvaluation(evaluation).subscribe(
        elem => {
          this.notificationService.sucess('Evaluation saved successfully.');
          this.onClear();
          console.log(elem);
          this.onClose();
        }
      );
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

  addSkillEvaluation() {
    const skillData: Skill = this.skillsList.find(s => s.id === this.evaluationService.form.controls.skillId.value);
    const skillEvaluationDetails: EvaluationDetails = {
      id: -1,
      evaluationId: -1,
      skillId: this.evaluationService.form.controls.skillId.value,
      skill: skillData,
      expertise: this.evaluationService.form.controls.weight.value
    };

    this.skillsWithEvaluation.push(skillEvaluationDetails);
  }

  deleteSkillWithEvaluation(skill: EvaluationDetails) {
    const index = this.skillsWithEvaluation.indexOf(skill, 0);
    if (index > -1) {
      this.skillsWithEvaluation.splice(index, 1);
      // if (this.projectPositionCriteria.skillsFilter.length === 0) {
      //   this.display = false;
      //   this.showContent = false;
      // }
    }
  }

  selected(name) {
    this.skillName = name;
  }
}

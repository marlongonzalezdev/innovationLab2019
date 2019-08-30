import {Component, Inject, OnInit} from '@angular/core';
import {EvaluationService} from '../../../shared/services/evaluation.service';
import {MAT_DIALOG_DATA, MatDialogRef} from '@angular/material';
import {Evaluation} from '../../../shared/models/evaluation';
import {Skill} from '../../../shared/models/skill';
import {Observable} from 'rxjs';
import {EvaluationType} from '../../../shared/models/evaluation-type';
import {SkillService} from '../../../shared/services/skill.service';
import {Candidate} from '../../../shared/models/candidate';
import {NotificationService} from '../../../shared/services/notification.service';

@Component({
  selector: 'app-evaluation',
  templateUrl: './evaluation.component.html',
  styleUrls: ['./evaluation.component.css']
})
export class EvaluationComponent implements OnInit {

  evaluationTypes: Observable<EvaluationType[]>;
  skillsList: Observable<Skill[]>;

  skillsWithEvaluation: Skill[] = [];

  constructor(private evaluationService: EvaluationService, private skillService: SkillService,
              private notificationService: NotificationService,
              public dialogRef: MatDialogRef<EvaluationComponent>, @Inject(MAT_DIALOG_DATA) private data: any) {
  }

  ngOnInit() {
    this.evaluationTypes = this.evaluationService.getEvaluationTypes();
    this.skillsList = this.skillService.getSkills();
  }

  onSubmit() {
    if (this.evaluationService.form.valid) {
      const evaluation: Evaluation = {
        id: -1,
        candidateId: this.data.id,
        date: new Date(),
        evaluationType: null,
        evaluationTypeId: this.evaluationService.form.controls.evaluationTypeId.value,
        skills: this.skillsWithEvaluation,
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
    const skill: Skill = {
      name: '',
      defaultExpertise: this.evaluationService.form.controls.weight.value,
      id: this.evaluationService.form.controls.skillId.value,
      versions: null,
      parentTechnologyId: null,
      isVersioned: null,
      code: null,
      category: null,
      relatedId: null,
      weight: null
    };

    this.skillsWithEvaluation.push(skill);
  }

  deleteSkillWithEvaluation(skill: Skill) {
    const index = this.skillsWithEvaluation.indexOf(skill, 0);
    if (index > -1) {
      this.skillsWithEvaluation.splice(index, 1);
      // if (this.project.skillsFilter.length === 0) {
      //   this.display = false;
      //   this.showContent = false;
      // }
    }
  }
}

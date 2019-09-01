import {EvaluationService} from './../../../shared/services/evaluation.service';
import {Component, OnInit} from '@angular/core';

import {Observable} from 'rxjs';
import {RelationType} from 'src/app/shared/models/relationType';
import {Candidate} from 'src/app/shared/models/candidate';
import {DeliveryUnit} from 'src/app/shared/models/deliveryUnit';
import {CandidateService} from 'src/app/shared/services/candidate.service';
import {DeliveryUnitService} from 'src/app/shared/services/delivery-unit.service';
import {RelationTypeService} from 'src/app/shared/services/relation-type.service';
import {NotificationService} from 'src/app/shared/services/notification.service';
import {MatDialogRef, MatOptionSelectionChange} from '@angular/material';
import {Role} from '../../../shared/models/role';
import {ProjectService} from '../../../shared/services/project.service';

import {CandidateGrade} from '../../../shared/models/candidate-grade';
import {Project} from '../../../shared/models/project';

@Component({
  selector: 'app-candidate',
  templateUrl: './candidate.component.html',
  styleUrls: ['./candidate.component.css']
})
export class CandidateComponent implements OnInit {

  deliveryUnits: Observable<DeliveryUnit[]>;
  relationTypes: Observable<RelationType[]>;
  projects: Observable<Project[]>;
  grades: Observable<CandidateGrade[]>;
  roles: Observable<Role[]>;
  public candidate: Candidate;
  isInBench: boolean;
  isEmployee: boolean;

  constructor(private candidateService: CandidateService, private deliveryUnitService: DeliveryUnitService,
              private relationTypeService: RelationTypeService, private notificationService: NotificationService,
              private projectService: ProjectService, public dialogRef: MatDialogRef<CandidateComponent>) {
  }

  ngOnInit() {
    this.deliveryUnits = this.deliveryUnitService.getDeliveryUnits();
    this.relationTypes = this.relationTypeService.getRelationTypes();
    this.projects = this.projectService.getProjects();
    this.grades = this.candidateService.getGrades();
    this.roles = this.candidateService.getCandidateRoles();
    this.isInBench = this.candidateService.form.controls.isInBench.value;
  }

  onClear() {
    this.candidateService.form.reset();
    this.candidateService.InitializeFormGroup();
  }

  onSubmit() {

    if (this.candidateService.form.valid) {
      console.log(this.candidateService.form.controls.$key.value);
      if (this.candidateService.form.controls.$key.value !== -1) {
        this.candidateService.getCandidateById(this.candidateService.form.controls.$key.value)
          .subscribe(response => {
            this.candidate = response;
            this.candidate.deliveryUnitId = this.candidateService.form.controls.du.value;
            this.candidate.relationType = this.candidateService.form.controls.relationType.value;
            this.candidate.firstName = this.candidateService.form.controls.firstName.value;
            this.candidate.lastName = this.candidateService.form.controls.lastName.value;
            this.candidate.candidateRoleId = this.candidateService.form.controls.roleId.value;
            this.candidate.inBench = this.candidateService.form.controls.isInBench.value;
            this.candidate.isActive = this.candidateService.form.controls.isActive.value;
            this.candidate.currentProjectId = this.candidateService.form.controls.project.value;
            this.candidate.grade = this.candidateService.form.controls.grade.value;
            this.candidateService.addCandidate(this.candidate).subscribe(
              elem => {
                this.notificationService.sucess('Candidate updated successfully.');
                this.onClear();
                console.log(elem);
                this.onClose();
              }
            );
          });
      } else {
        const newCandidate: Candidate = {
          id: -1,
          deliveryUnitId: this.candidateService.form.controls.du.value,
          deliveryUnit: null,
          relationType: this.candidateService.form.controls.relationType.value,
          firstName: this.candidateService.form.controls.firstName.value,
          lastName: this.candidateService.form.controls.lastName.value,
          currentProjectId: this.candidateService.form.controls.project.value,
          candidateRoleId: this.candidateService.form.controls.roleId.value,
          grade: this.candidateService.form.controls.grade.value,
          project: null,
          name: '',
          candidateRole: null,
          docType: null,
          docNumber: null,
          employeeNumber: null,
          inBench: this.candidateService.form.controls.isInBench.value,
          picture: null,
          isActive: this.candidateService.form.controls.isActive.value,
          gradeDescription: null,
          currentProjectDescription: null,
          currentProjectDuration: null,
          evaluations: null
        };
        this.candidateService.addCandidate(newCandidate).subscribe(
          elem => {
            this.notificationService.sucess('Candidate saved successfully.');
            this.onClear();
            console.log(elem);
            this.onClose();
          }
        );
      }

    }
  }

  onClose() {
    this.onClear();
    this.dialogRef.close();
  }

  selected(event) {
    this.isInBench = event.checked ? true : false;
  }

  onSelect(change: MatOptionSelectionChange) {
    if (change.source.selected) {
      const relationselected = change.source.viewValue;
      if (relationselected === 'Employee') {
        this.isEmployee = true;
        this.isInBench = this.candidateService.form.controls.isInBench.value;
      } else {
        this.isEmployee = false;
        this.isInBench = this.candidateService.form.controls.isInBench.value;
      }
    }
  }
}

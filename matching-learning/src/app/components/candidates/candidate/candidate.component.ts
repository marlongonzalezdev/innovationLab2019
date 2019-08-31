import {Component, OnInit} from '@angular/core';

import {Observable} from 'rxjs';
import {RelationType} from 'src/app/shared/models/relationType';
import {Candidate} from 'src/app/shared/models/candidate';
import {DeliveryUnit} from 'src/app/shared/models/deliveryUnit';
import {CandidateService} from 'src/app/shared/services/candidate.service';
import {DeliveryUnitService} from 'src/app/shared/services/delivery-unit.service';
import {RelationTypeService} from 'src/app/shared/services/relation-type.service';
import {NotificationService} from 'src/app/shared/services/notification.service';
import {MatDialogRef} from '@angular/material';
import {Role} from '../../../shared/models/role';
import {CandidateRolHistory} from '../../../shared/models/rolesHistory';

@Component({
  selector: 'app-candidate',
  templateUrl: './candidate.component.html',
  styleUrls: ['./candidate.component.css']
})
export class CandidateComponent implements OnInit {

  deliveryUnits: Observable<DeliveryUnit[]>;
  relationTypes: Observable<RelationType[]>;
  roles: Observable<Role[]>;

  constructor(private candidateService: CandidateService, private deliveryUnitService: DeliveryUnitService,
              private relationTypeService: RelationTypeService, private notificationService: NotificationService,
              public dialogRef: MatDialogRef<CandidateComponent>) {
  }

  ngOnInit() {
    this.deliveryUnits = this.deliveryUnitService.getDeliveryUnits();
    this.relationTypes = this.relationTypeService.getRelationTypes();
    this.roles = this.candidateService.getCandidateRoles();
  }

  onClear() {
    this.candidateService.form.reset();
    this.candidateService.InitializeFormGroup();
  }

  onSubmit() {
    if (this.candidateService.form.valid) {

      const currentRole: Role = {
        id: this.candidateService.form.controls.roleId.value,
        code: '',
        name: ''
      };

      const candidateRolHistory: CandidateRolHistory = {
        id: -1,
        start: new Date(),
        end: null,
        role: currentRole,
      };

      const candidate: Candidate = {
        id: -1,
        deliveryUnitId: this.candidateService.form.controls.du.value,
        deliveryUnit: null,
        relationType: this.candidateService.form.controls.relationType.value,
        firstName: this.candidateService.form.controls.firstName.value,
        lastName: this.candidateService.form.controls.lastName.value,
        name: '',
        candidateRolHistory: [],
        activeRole: null,
        docType: null,
        docNumber: null,
        employeeNumber: null,
        inBench: this.candidateService.form.controls.isInBench.value,
        picture: null,
        isActive: this.candidateService.form.controls.isActive.value,
        evaluations: null
      };
      candidate.candidateRolHistory.push(candidateRolHistory);

      this.candidateService.addCandidate(candidate).subscribe(
        elem => {
          this.notificationService.sucess('Candidate saved successfully.');
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
}

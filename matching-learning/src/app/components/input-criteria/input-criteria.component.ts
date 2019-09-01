import { Component, Input, OnInit } from '@angular/core';
import { ProjectPositionCriteria } from '../../shared/models/projectPositionCriteria';
import { Skill } from 'src/app/shared/models/skill';
import { SkillsFilter } from '../../shared/models/skillsFilter';
import { DeliveryUnitService } from 'src/app/shared/services/delivery-unit.service';
import { Observable } from 'rxjs';
import { DeliveryUnit } from 'src/app/shared/models/deliveryUnit';
import { FormBuilder, FormGroup } from '@angular/forms';
import { SkillServiceBase } from '../../shared/services/skill-service-base';
import {Role} from '../../shared/models/role';

@Component({
  selector: 'app-input-criteria',
  templateUrl: './input-criteria.component.html',
  styleUrls: ['./input-criteria.component.css']
})
export class InputCriteriaComponent implements OnInit {

  projectPositionCriteria: ProjectPositionCriteria;
  display: boolean;
  skillList: Skill[] = [];

  selectedSkill: Skill;
  expectedScore: number;
  showContent: boolean;

  options: FormGroup;

  deliveryUnits: Observable<DeliveryUnit[]>;
  defaultDeliveryUnit: Observable<DeliveryUnit>;
  candidateRoles: Observable<Role[]>;

  constructor(private skillService: SkillServiceBase, private deliveryUnitService: DeliveryUnitService, fb: FormBuilder) {
      this.projectPositionCriteria = {
      name: 'Example',
      max: 10,
      skillsFilter: [],
      deliveryUnitIdFilter: null,
      inBenchFilter: false,
      relationTypeFilter: null,
      roleIdFilter: null
    };
      this.display = false;
      this.showContent = false;

      this.options = fb.group({
      hideRequired: false,
      floatLabel: 'auto',
    });
  }

  ngOnInit() {
    this.deliveryUnits = this.deliveryUnitService.getDeliveryUnits();
    this.candidateRoles = this.deliveryUnitService.getRoles();

    this.defaultDeliveryUnit = this.deliveryUnitService.getDefaultDeliveryUnit();
	// this.projectPositionCriteria.deliveryUnitIdFilter = this.defaultDeliveryUnit.id;

    this.skillService.getSkillsSorted()
      .subscribe ( response => {
         this.skillList = response;
      });
  }

  add(skill: Skill): void {

    if (!skill || !this.expectedScore) {
      return;
    }
    if (!this.projectPositionCriteria.skillsFilter.find(s => s.requiredSkillId === skill.id)) {
        const skillsFilter: SkillsFilter = {
        requiredSkillId: skill.id,
        weight: this.expectedScore,
        minAccepted: null,
        name: skill.name
      };
        this.projectPositionCriteria.skillsFilter.push(skillsFilter);
        this.selectedSkill = undefined;
        this.expectedScore = undefined;
    }
    this.display = true;
  }

  delete(skill: SkillsFilter): void {
    const index = this.projectPositionCriteria.skillsFilter.indexOf(skill, 0);
    if (index > -1) {
      this.projectPositionCriteria.skillsFilter.splice(index, 1);
      if (this.projectPositionCriteria.skillsFilter.length === 0) {
        this.display = false;
        this.showContent = false;
      }
    }
  }
}

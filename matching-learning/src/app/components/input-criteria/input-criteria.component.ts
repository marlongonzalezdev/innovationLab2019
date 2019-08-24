import { Component, Input, OnInit} from '@angular/core';
import { Project } from '../../shared/models/project';
import { SkillServiceBase } from '../skills/services/skill-service-base';
import { Skill } from 'src/app/shared/models/skill';
import {SkillsFilter} from '../../shared/models/skillsFilter';
import { DeliveryUnitService } from 'src/app/shared/services/delivery-unit.service';
import { Observable } from 'rxjs';
import { DeliveryUnit } from 'src/app/shared/models/deliveryUnit';
import {FormBuilder, FormGroup} from '@angular/forms';

@Component({
  selector: 'app-input-criteria',
  templateUrl: './input-criteria.component.html',
  styleUrls: ['./input-criteria.component.css']
})
export class InputCriteriaComponent implements OnInit {

  project: Project;
  display: boolean;
  skillList: Skill[] = [];

  selectedSkill: Skill;
  expectedScore: number;
  showContent: boolean;

  options: FormGroup;

  deliveryUnits: Observable<DeliveryUnit[]>;

  constructor(private skillService: SkillServiceBase, private deliveryUnitService: DeliveryUnitService, fb: FormBuilder) {
      this.project = {
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

    this.skillService.getSkills()
      .subscribe ( response => {
         this.skillList = response;
      });
  }

  add(skill: Skill): void {

    if (!skill || !this.expectedScore) {
      return;
    }
    if (!this.project.skillsFilter.find(s => s.requiredSkillId === skill.id)) {
        const skillsFilter: SkillsFilter = {
        requiredSkillId: skill.id,
        weight: this.expectedScore,
        minAccepted: null,
        name: skill.name
      };
        this.project.skillsFilter.push(skillsFilter);
        this.selectedSkill = undefined;
        this.expectedScore = undefined;
    }
    this.display = true;
  }

  delete(skill: SkillsFilter): void {
    const index = this.project.skillsFilter.indexOf(skill, 0);
    if (index > -1) {
      this.project.skillsFilter.splice(index, 1);
      if (this.project.skillsFilter.length === 0) {
        this.display = false;
        this.showContent = false;
      }
    }
  }
}

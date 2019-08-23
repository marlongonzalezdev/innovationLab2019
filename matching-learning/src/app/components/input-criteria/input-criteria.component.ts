import { Component, Input, OnInit } from '@angular/core';
import { Project } from '../../shared/models/project';
import {SkillsFilter} from '../../shared/models/skillsFilter';
import { Skill } from '../../shared/models/skill';
import { SkillServiceBase } from '../../shared/services/skill-service-base';

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

  constructor(private skillService: SkillServiceBase) {
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
  }

  ngOnInit() {

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
      /*skill.weight = this.expectedScore / 100;*/
      const skillsFilter: SkillsFilter = {
        requiredSkillId: skill.id,
        weight: this.expectedScore / 100,
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

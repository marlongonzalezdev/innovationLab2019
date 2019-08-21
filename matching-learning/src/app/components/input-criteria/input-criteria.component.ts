import { Component, Input, OnInit } from '@angular/core';
import { Project } from '../../project';
import { SkillServiceBase } from '../skills/services/skill-servie-base';
import { Skill } from 'src/app/models/skill';

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
    this.project = new Project();
    this.project.name = 'Example';
    this.project.skills = [];
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
    if (!this.project.skills.find(s => s.id === skill.id)) {
      skill.weight = this.expectedScore / 100;
      this.project.skills.push(skill);
      this.selectedSkill = undefined;
      this.expectedScore = undefined;
    }
    this.display = true;
  }

  delete(skill: Skill): void {
    const index = this.project.skills.indexOf(skill, 0);
    if (index > -1) {
      this.project.skills.splice(index, 1);
      if (this.project.skills.length === 0) {
        this.display = false;
        this.showContent = false;
      }
    }
  }
}

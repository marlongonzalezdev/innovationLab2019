import { Component, OnInit } from '@angular/core';
import {Skills} from '../mock-skills'
import { Skill } from '../skill';
import { Project } from '../project';

@Component({
  selector: 'app-skills',
  templateUrl: './skills.component.html',
  styleUrls: ['./skills.component.css']
})
export class SkillsComponent implements OnInit {
  project: Project;
  
  skillList = Skills;

  selectedSkill: Skill;
  expectedScore: number;

  constructor() { 
    this.project = new Project();
    this.project.name= "Example";
    this.project.skills = [];
  }

  ngOnInit() {
  }

  add(skill: Skill): void {

    if (!skill || !this.expectedScore) { return; }
    if (!this.project.skills.find(s => s === skill)) {
      skill.weight = this.expectedScore;
      this.project.skills.push(skill);
      this.selectedSkill = undefined;
      this.expectedScore = undefined;
    }
  }

  delete(name: string): void {
  }
}

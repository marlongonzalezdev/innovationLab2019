import { Component, OnInit } from '@angular/core';
import {Skills} from '../mock-skills'
import { Skill } from '../skill';

@Component({
  selector: 'app-skills',
  templateUrl: './skills.component.html',
  styleUrls: ['./skills.component.css']
})
export class SkillsComponent implements OnInit {
  skills: Skill[] = [];

  skillList = Skills;

  selectedSkill: Skill;
  expectedScore: number;

  constructor() { }

  ngOnInit() {
  }

  add(skill: Skill): void {

    if (!skill || !this.expectedScore) { return; }
    if (!this.skills.find(s => s === skill)) {
      skill.weight = this.expectedScore;
      this.skills.push(skill);
      this.selectedSkill = undefined;
      this.expectedScore = undefined;
    }
  }

  delete(name: string): void {

  }

}

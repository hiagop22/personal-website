// import { NgClass } from '@angular/common';
import { NgIf, NgStyle } from '@angular/common';
import { Component, ElementRef } from '@angular/core';

// declare const angular: any;

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [NgIf,
            NgStyle,
            ],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent {
  constructor(){}

  // menu: string = "menu";
  // menuIsClicked: boolean = false;

  ngOnInit(): void{};

  // myFunc() {
  //   this.menuIsClicked = !this.menuIsClicked;

  //   if(this.menuIsClicked){
  //     this.menu ="close";
  //   }
  //   else {
  //     this.menu = "menu";
  //   }
  // }
}

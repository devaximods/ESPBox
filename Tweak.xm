static void CreateUI() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (!root || !root.view) return;
        
        allButtons = [NSMutableArray new];
        
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        CGFloat btnW = 100;
        CGFloat btnH = 40;
        
        // Petit texte XSNPMODZZZ en haut à gauche
        UILabel *xsnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 15)];
        xsnLabel.text = @"XSNPMODZZZ";
        xsnLabel.textColor = [UIColor colorWithRed:0.6 green:0.2 blue:1.0 alpha:0.7];
        xsnLabel.font = [UIFont systemFontOfSize:9];
        [root.view addSubview:xsnLabel];
        
        // Bouton secret en haut à droite
        secretButton = [[SecretButton alloc] initWithFrame:CGRectMake(screenW - 50, 45, 40, 40)];
        [secretButton addTarget:nil action:@selector(toggleSecret) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:secretButton];
        
        // === BOUTONS DISPERSÉS ===
        
        // ESP BOX - en haut au milieu
        DraggableButton *btn1 = [[DraggableButton alloc] initWithFrame:CGRectMake(screenW/2 - btnW/2, 100, btnW, btnH) title:@"ESP BOX"];
        [btn1 addTarget:nil action:@selector(toggleESPBox) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btn1];
        [allButtons addObject:btn1];
        
        // ESP LINE - à gauche, un peu plus bas
        DraggableButton *btn2 = [[DraggableButton alloc] initWithFrame:CGRectMake(20, 180, btnW, btnH) title:@"ESP LINE"];
        [btn2 addTarget:nil action:@selector(toggleESPLine) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btn2];
        [allButtons addObject:btn2];
        
        // ESP DIST - à droite, un peu plus bas
        DraggableButton *btn3 = [[DraggableButton alloc] initWithFrame:CGRectMake(screenW - btnW - 20, 180, btnW, btnH) title:@"ESP DIST"];
        [btn3 addTarget:nil action:@selector(toggleESPDistance) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btn3];
        [allButtons addObject:btn3];
        
        // ESP HEALTH - au milieu, plus bas
        DraggableButton *btn4 = [[DraggableButton alloc] initWithFrame:CGRectMake(screenW/2 - btnW/2, 270, btnW, btnH) title:@"ESP HEALTH"];
        [btn4 addTarget:nil action:@selector(toggleESPHealth) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btn4];
        [allButtons addObject:btn4];
        
        // AIMBOT - à gauche, en bas
        DraggableButton *btn5 = [[DraggableButton alloc] initWithFrame:CGRectMake(20, screenH - 100, btnW, btnH) title:@"AIMBOT"];
        [btn5 addTarget:nil action:@selector(toggleAimbot) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btn5];
        [allButtons addObject:btn5];
        
        // SPINBOT - à droite, en bas
        DraggableButton *btn6 = [[DraggableButton alloc] initWithFrame:CGRectMake(screenW - btnW - 20, screenH - 100, btnW, btnH) title:@"SPINBOT"];
        [btn6 addTarget:nil action:@selector(toggleSpinbot) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btn6];
        [allButtons addObject:btn6];
        
        NSLog(@"✅ UI créée : 6 boutons dispersés");
    });
}
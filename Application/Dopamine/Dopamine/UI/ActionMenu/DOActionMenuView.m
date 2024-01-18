//
//  DOActionMenuView.m
//  Dopamine
//
//  Created by tomt000 on 04/01/2024.
//

#import "DOActionMenuView.h"
#import "DOActionMenuButton.h"

#define UI_INNER_PADDING 20
#define UI_INNER_TOP_PADDING 5
#define UI_ACTION_HEIGHT 73

@implementation DOActionMenuView

- (instancetype)initWithActions:(NSArray<UIAction*> *)actions delegate:(id<DOActionMenuDelegate>)delegate
{
    if (self = [super init])
    {
        [self setDelegate:delegate];
        [self setActions:actions];
        self.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.45];
        self.layer.cornerRadius = 14;
        self.layer.masksToBounds = YES;
        self.layer.cornerCurve = kCACornerCurveContinuous;
    }
    return self;
}

- (void)setActions:(NSArray *)actions
{
    _actions = actions;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshStack];
    });
}

-(void)refreshStack
{
    [self.buttonsView removeFromSuperview];
    self.buttonsView = [[UIStackView alloc] init];
    self.buttonsView.axis = UILayoutConstraintAxisVertical;
    self.buttonsView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.actions enumerateObjectsUsingBlock:^(UIAction *action, NSUInteger idx, BOOL *stop) {
        DOActionMenuButton *button = [DOActionMenuButton buttonWithAction:action chevron:[self.delegate actionMenuShowsChevronForAction:action]];
        [button setBottomSeparator:idx != self.actions.count - 1];
        [self.buttonsView addArrangedSubview:button];
        [NSLayoutConstraint activateConstraints:@[
            [button.heightAnchor constraintEqualToConstant:UI_ACTION_HEIGHT],
            [button.widthAnchor constraintEqualToAnchor:self.buttonsView.widthAnchor]
        ]];
    }];

    [self addSubview:self.buttonsView];

    [NSLayoutConstraint activateConstraints:@[
        [self.buttonsView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:UI_INNER_PADDING],
        [self.buttonsView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-UI_INNER_PADDING],
        [self.buttonsView.topAnchor constraintEqualToAnchor:self.topAnchor constant:UI_INNER_TOP_PADDING],
        [self.buttonsView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-UI_INNER_TOP_PADDING],
    ]];
}

- (void)hide
{
    [self setUserInteractionEnabled:NO];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -75);
    transform = CGAffineTransformScale(transform, 0.6, 0.6);
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:2.0  options: UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setAlpha:0.0];
        [self setTransform:transform];
    } completion:nil];
}

@end